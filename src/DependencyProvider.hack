namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;
use type ReflectionMethod;
use function array_key_exists;

final class DependencyProvider<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private ProviderInterface $provider,
    private \Nazg\Glue\Container $container
  ) {}

  public function resolve(
    Scope $scope
  ): T {
    if ($this->instance is nonnull) {
      return $this->shared();
    }
    $this->instance = $this->provider->get($this->container);
    return $this->instance;
  }
}
