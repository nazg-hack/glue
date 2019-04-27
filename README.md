# Nazg\Glue

Dependency Injection Container For Hack

[![Build Status](https://travis-ci.org/nazg-hack/glue.svg?branch=master)](https://travis-ci.org/nazg-hack/glue)

## Requirements

HHVM 4.0.0 and above.

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

|   |    |
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

$builder = new ContainerBuilder(true, __DIR__ . '/your/serialized.filename');
// return a \Nazg\Glue\CachedContainer Instance
$container = $builder->make();
```
