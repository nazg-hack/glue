namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;

final class DependencyFactory {
  
  public function __construct(
    private \Nazg\Glue\Container $container
  ) {}

  public function createInstance<T>(
    typename<T> $concrete
  ): DependencyInterface {
    return new Dependency(new ReflectionClass($concrete), $this->container);
  }
}
