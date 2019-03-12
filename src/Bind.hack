namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};

use type ReflectionClass;

class Bind<T> {
  private Scope $scope = Scope::SINGLETON;
  private ?DependencyInterface $bound;

  public function __construct(
    private \Nazg\Glue\Container $container,
    private typename<T> $id,
  ) {}

  public function to<Tc>(
    typename<Tc> $concrete,
    Scope $scope = Scope::SINGLETON
  ): void {
    $factory = new DependencyFactory($this->container);
    $this->scope = $scope;
    $this->bound = $factory->createInstance($concrete);
    $this->container->add($this);
  }

  public function getId(): string {
    return $this->id;
  }

  public function getBound(): ?DependencyInterface {
    return $this->bound;
  }

  public function getScope(): Scope {
    return $this->scope;
  }
}
