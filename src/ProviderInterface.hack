namespace Nazg\Glue;

interface ProviderInterface<T> {

  public function get(): T;
}
