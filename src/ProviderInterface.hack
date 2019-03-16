namespace Nazg\Glue;

interface ProviderInterface<T> {

  public function get(
    \Nazg\Glue\Container $container
  ): T;
}
