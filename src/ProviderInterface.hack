namespace Nazg\Glue;

<<__ConsistentConstruct>>
interface ProviderInterface {

  public function get<T>(
    \Nazg\Glue\Container $container
  ): T;
}
