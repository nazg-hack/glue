namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;
use type ReflectionMethod;
use function array_key_exists;

final class Dependency<T> implements DependencyInterface {
  
  private ?Bind<T> $bind;
  private ?T $instance;

  public function __construct(
    private ReflectionClass $reflection,
    private \Nazg\Glue\Container $container
  ) {}

  public function resolve(
    \Nazg\Glue\Container $container,
    Scope $scope
  ): T {
    $construtor = $this->reflection->getConstructor();
    if($this->reflection->isInstantiable()) {
      if($scope === Scope::SINGLETON) {
        if ($this->instance is nonnull) {
          return $this->shared();
        }
      }
      if ($construtor is ReflectionMethod) {
        if ($construtor->getNumberOfParameters() === 0) {
          $this->instance = $this->reflection->newInstance();
          return $this->instance;
        }
        $arguments = vec[];
        foreach($construtor->getParameters() as $parameter) {
          $arguments[] = $this->container->get($parameter->getTypehintText());
        }
        $this->instance = $this->reflection->newInstanceArgs($arguments);
        return $this->instance;
      }
      $this->instance = $this->reflection->newInstance();
      return $this->instance;
    }
    throw new \RuntimeException();
  }

  <<__Memoize>>
  protected function shared(): T {
    if ($this->instance is nonnull) {
      return $this->instance;
    }
    throw new \RuntimeException();
  }
}
