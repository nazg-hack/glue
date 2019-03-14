namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;

final class DependencyFactory {
  
  public function __construct(
    private \Nazg\Glue\Container $container
  ) {}

  public function makeInstance<T>(
    typename<T> $concrete
  ): DependencyInterface {
    return new Dependency(
      new Injector(new ReflectionClass($concrete)), $this->container
    );
  }

  public function makeInstanceByProvider(
    classname<ProviderInterface> $provider
  ): DependencyInterface {
    $provide = new $provider();
    return new DependencyProvider($provide, $this->container);
  }
}
