namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};

use type ReflectionClass;

/**
 *
 *
 */
class Bind<T> {
  private Scope $scope = Scope::SINGLETON;
  private ?DependencyInterface $bound;

  public function __construct(
    private \Nazg\Glue\Container $container,
    private typename<T> $id,
  ) {}

  public function to<Tc>(
    Scope $scope,
    typename<Tc> $concrete
  ): void {
    $factory = new DependencyFactory();
    $this->scope = $scope;
    $this->bound = $factory->closureDependency($concrete);
    $this->container->add($this);
  }

  public function getId(): string {
    return $this->id;
  }

  public function getBound(): ?DependencyInterface {
    return $this->bound;
  }
}
