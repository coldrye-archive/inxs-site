---
template: index.jade
---

## Introduction

inxs is an extensible dependency injection framework.

It provides you with the means to inject dependencies into class methods and properties.

All you have to do is to provide a suitable factory, we refer to it as the broker, for creating the instances of the interfaces that you can refer to either by name or by prototype function.


## Basic Usage

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

