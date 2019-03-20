namespace Nazg\Glue;

use type ReflectionClass;

final class DependencyFactory {

  public function __construct(
    private \Nazg\Glue\Container $container
  ) {}

  public function makeInstance<T>(
    typename<T> $concrete
  ): DependencyInterface {
    return new Dependency(
      new Injector(new ReflectionClass($concrete))
    );
  }

  public function makeInstanceByProvider<T>(
    ProviderInterface<T> $provider
  ): DependencyInterface {
    return new DependencyProvider($provider);
  }
}
