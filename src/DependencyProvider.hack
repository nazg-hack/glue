namespace Nazg\Glue;

final class DependencyProvider<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private ProviderInterface<T> $provider,
    private \Nazg\Glue\Container $container
  ) {}

  <<__Override>>
  public function resolve(
    Scope $scope
  ): T {
    if($scope === Scope::SINGLETON) {
      if ($this->instance is nonnull) {
        return $this->shared();
      }
    }
    $this->instance = $this->provider->get($this->container);
    return $this->instance;
  }
}
