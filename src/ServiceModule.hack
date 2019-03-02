namespace Nazg\Glue;

use type Nazg\Glue\Container;

<<__ConsistentConstruct>>
abstract class ServiceModule {

  abstract public function provide<T>(
    Container<T> $container
  ): void;
}
