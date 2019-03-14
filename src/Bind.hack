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
    $factory = $this->getFactory();
    $this->scope = $scope;
    $this->bound = $factory->makeInstance($concrete);
    $this->container->add($this);
  }

  public function in(Scope $scope): void {

  }

  public function provider(
    classname<ProviderInterface> $provider
  ) : void {
    $factory = $this->getFactory();
    $this->scope = Scope::SINGLETON;
    $this->bound = $factory->makeInstanceByProvider($provider);
    $this->container->add($this);
  }

  <<__Memoize>>
  protected function getFactory(): DependencyFactory {
    return new DependencyFactory($this->container);
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
