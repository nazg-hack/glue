<?hh // strict

namespace Nazg\Glue;

use type Nazg\Glue\Container;

<<__ConsistentConstruct>>
abstract class ServiceModule {

  abstract public function provide(
    Container $container
  ): void;
}
