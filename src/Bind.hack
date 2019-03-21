namespace Nazg\Glue;

final class Bind<T> {
  private Scope $scope = Scope::SINGLETON;
  private ?DependencyInterface $bound;

  public function __construct(
    private \Nazg\Glue\Container $container,
    private typename<T> $id,
  ) {}

  public function to<Tc>(
    typename<Tc> $concrete
  ): this {
    $factory = $this->getFactory();
    $this->bound = $factory->makeInstance($concrete);
    $this->container->add($this);
    return $this;
  }

  public function in(Scope $scope): this {
    $this->scope = $scope;
    $this->container->add($this);
    return $this;
  }

  public function provider<Tp>(
    ProviderInterface<Tp> $provider
  ) : this {
    $factory = $this->getFactory();
    $this->bound = $factory->makeInstanceByProvider($provider);
    $this->container->add($this);
    return $this;
  }

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
