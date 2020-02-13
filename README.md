# Nazg\Glue

Dependency Injection Container For Hack

[![Travis (.org)](https://img.shields.io/travis/nazg-hack/glue.svg?style=flat-square)](https://travis-ci.org/nazg-hack/glue)
[![Packagist](https://img.shields.io/packagist/dt/nazg/glue.svg?style=flat-square)](https://packagist.org/packages/nazg/glue)
[![Packagist Version](https://img.shields.io/packagist/v/nazg/glue.svg?color=orange&style=flat-square)](https://packagist.org/packages/nazg/glue)
[![Packagist](https://img.shields.io/packagist/l/nazg/glue.svg?style=flat-square)](https://packagist.org/packages/nazg/glue)

## Requirements

HHVM 4.35.0 and above.

## Installation
Composer is the recommended installation method.  
To add Nazg\Glue to your project, add the following to your composer.json then re-run composer:

```json
  "require": {
    "nazg/glue": "^1.4"
  }
```

Run Composer commands using HHVM like so:

```bash
$ composer install
```

In addition, you will need to use hhvm-autoload as your autoloader.

or

```bash
$ composer require nazg/glue
```

## Usage

### First steps

#### Create Class

```hack
interface AnyInterface {

}
```

```hack
final class Any implements AnyInterface {
  // any
}
```

#### Bindings

```hack
use type Nazg\Glue\Container;
use type Nazg\Glue\Scope;

$container = new Container();
$container->bind(AnyInterface::class)
  ->to(Mock::class)
  ->in(Scope::PROTOTYPE);
\HH\Asio\join($container->lockAsync());

```

dependencies will be automatically resolved

```hack
$container->get(AnyInterface::class);
```

### Scopes

use the `Nazg\Glue\Scope` enum.

```hack
enum Scope : int {
  PROTOTYPE = 0;
  SINGLETON = 1;
}
```

| enum |    |
|-----------|----------|
| `Nazg\Glue\Scope\PROTOTYPE` | single instance |
| `Nazg\Glue\Scope\SINGLETON` | prototype instance  |

### Providers

use \Nazg\Glue\ProviderInterface.

```hack
use type Nazg\Glue\ProviderInterface;

final class AnyProvider implements ProviderInterface<AnyInterface> {

  public function get(): AnyInterface {
    return new Any();
  }
}
```

```hack
$container->bind(AnyInterface::class)
  ->provider(new AnyProvider();
```

### Binding Serialization Cache

```hack
use type Nazg\Glue\ContainerBuilder;

$builder = new ContainerBuilder(true, 'apc.cache.key.name');
// return a \Nazg\Glue\CachedContainer Instance
$container = $builder->make();
```
