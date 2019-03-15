namespace Nazg\Glue;


final class Dependency<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private Injector $injector,
    private \Nazg\Glue\Container $container
  ) {}

  <<__Override>>
  public function resolve(
    Scope $scope
  ): T {
    list($reflection, $args) = $this->injector->getReflectionClass();
    if($scope === Scope::SINGLETON) {
      if ($this->instance is nonnull) {
        return $this->shared();
      }
    }
    if($args is vec<_>) {
      $parameters = vec[];
      foreach($args as $arg) {
        $parameters[] = $this->container->get($arg);
      }
      $this->instance = $reflection->newInstanceArgs($parameters);
      return $this->instance;
    }
    $this->instance = $reflection->newInstance();
    return $this->instance;
  }
}
