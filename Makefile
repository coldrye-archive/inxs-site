# vim: noexpandtab:ts=4:sw=4

# Copyright 2015 Carsten Klein
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.


build_dir       = ./build
dist_dir        = ./dist
src_dir         = ./src
artwork_dir     = ../inxs-artwork/dist
inxs_project_dir        = ../inxs
inxs_common_project_dir = ../inxs-common


.PHONY: dist build-assets build-externals build-src \
		bower clean clean-build clean-dist \
        deps deps-global


# transpiles both src and test
dist: clean $(build_dir)/ $(dist_dir)/ build-src build-assets build-externals bower
	@cd build && wintersmith build


build-src:
	cp -vr $(src_dir)/* $(build_dir)


$(build_dir)/:
	@mkdir $(build_dir)
	@ln -s ../node_modules $(build_dir)/


$(dist_dir)/:
	@mkdir $(dist_dir)


bower:
	@bower install


# internal
build-assets: $(build_dir)/contents/images/
	@echo "gathering assets..."
	@cp ../inxs-artwork/dist/favicon.png $(build_dir)/contents/
	@cp ../inxs-artwork/dist/logo-60x80.png $(build_dir)/contents/images/logo.png


$(build_dir)/contents/images/:
	mkdir -p $(build_dir)/contents/images


# internal
build-externals:
	@echo "building externals..."
	@make -C ../inxs cover doc devdoc
	@make -C ../inxs-common cover devdoc
	@mkdir -p $(build_dir)/contents/projects/inxs
	@mkdir -p $(build_dir)/contents/projects/inxs-common
	@cp -a ../inxs/build/doc build/contents/projects/inxs/doc
	@cp -a ../inxs/build/cover build/contents/projects/inxs/cover
	@cp -a ../inxs-common/build/doc build/contents/projects/inxs-common/doc
	@cp -a ../inxs-common/build/cover build/contents/projects/inxs-common/cover


# cleans both the build and dist directory 
clean: clean-build clean-dist


# internal
clean-build:
	@echo "cleaning build..."
	@-rm -Rf $(build_dir)


# internal
clean-dist:
	@echo "cleaning dist..."
	@-rm -Rf $(dist_dir)


# installs local (dev) dependencies
deps:
	@echo "installing local (dev) dependencies..."
	@npm install 


# installs global dev dependencies
deps-global:
	@echo "installing global dev dependencies (sudo)..."
	@sudo npm -g install $(shell node -e " \
		var pkg = require('./package.json'); \
		var deps = []; \
        for (var key in pkg.globalDevDependencies) { \
			var version = pkg.globalDevDependencies[key]; \
			if (version.indexOf('/') != -1) { \
				deps.push(version); \
			} \
			else { \
				deps.push(key + '@' + version); \
			} \
		} \
		console.log(deps.join(' ')); \
    ")

