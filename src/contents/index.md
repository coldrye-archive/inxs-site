---
template: index.jade
---

## Introduction

``inxs`` is an extensible dependency injection framework based on the ``decorator 
language`` feature.

It provides you with the means to inject dependencies into class methods and
properties.

All you have to do is to provide a suitable ``factory``, we refer to it as the
[broker](./projects/inxs/doc/dev/typedef/index.html#static-typedef-AbstractBroker), for 
creating the instances of the interfaces you specify in the decorator. You 
can refer to these interfaces either by name or by their prototype function,
depending on how you implement your broker.

Apart from such fundamental API design decisions, ``inxs`` is rather unopinionated
as to how you resolve the interfaces or create the instances. In fact, ``inxs``
does not even cache the instances it gets from the ``broker`` so you are free to
implement your own caching mechanism, or hand out proxies and do whatever 
complicated stuff you need to do in order to get your application running.

You can even define multiple instances of the ``injection decorator`` for use with
different usage scenarios, say one for local operations and one for remoting, and
so on. The possibilities are endless.


## Basic Usage

In this usage scenario we will define a custom ``broker`` that acts as the factory
for our named interfaces.


### Integration Layer (broker.es)

<pre class="prettyprint lang-javascript">
import inxs from 'inxs';

class MyBroker
{
    getInstance(iface)
    {
        if (iface == 'hello')
        {
            return new HelloWorldWidget();
        }

        throw new TypeError('unsupported interface ' + iface);
    }
}

const inject = inxs(new MyBroker());

class HelloWorldWidget
{
    doSomething()
    {
        console.log('hello world');
    }
}

export default inject;
</pre>


### Using the Integration Layer

<pre class="prettyprint lang-javascript">
import inject from './broker';

class MyApp
{
    @inject('hello')
    get widget
    {}

    run()
    {
        this.widget.doSomething();
    }
}
</pre>


## Advanced Usage

Here, we will define our own custom suite of injectors and pass these in as the
second argument to the ``inxs decorator factory``.

For simplicity's sake we will reuse the injectors from the ``inxs``
[implementation module](./projects/inxs/doc/dev/file/src/impl.es.html).

**Please note** that the classes in that module are private and that you eventually
will have to implement your own suite of injectors to accomplish the stuff that you
really want to do.


### Integration Layer (broker.es)

<pre class="prettyprint lang-javascript">
import inxs from 'inxs';

import * as impl from 'inxs/lib/impl';

class MyBroker
{
    getInstance(iface)
    {
        if (iface == 'hello')
        {
            return new HelloWorldWidget();
        }

        throw new TypeError('unsupported interface ' + iface);
    }
}

const injectors = [new impl.StaticPropertyInjectorImpl()];

const inject = inxs(new MyBroker(), injectors);

class HelloWorldWidget
{
    doSomething()
    {
        console.log('hello world');
    }
}

export default inject;
</pre>


### Using the Integration Layer

As for using the new integration layer, this is pretty straight forward and
very similar to the above with the difference being that we are now limited
to static property injection, only.

<pre class="prettyprint lang-javascript">

class MyApp
{
    @inject('hello')
    static get widget
    {}

    run()
    {
        MyApp.widget.doSomething();
    }
}
</pre>

## Further Reading

- [Dependency Injection](https://de.wikipedia.org/wiki/Dependency_Injection)
- [Exploring ES7 Decorators](https://medium.com/google-developers/exploring-es7-decorators-76ecb65fb841)

