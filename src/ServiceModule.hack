namespace Nazg\Glue;

<<__ConsistentConstruct>>
abstract class ServiceModule {

  abstract public function provide(
    \Nazg\Glue\Container $container
  ): void;
}
