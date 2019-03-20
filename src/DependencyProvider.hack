namespace Nazg\Glue;

final class DependencyProvider<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private ProviderInterface<T> $provider
  ) {}

  <<__Override>>
  public function resolve(
    \Nazg\Glue\Container $container,
    Scope $scope
  ): T {
    if($scope === Scope::SINGLETON) {
      if ($this->instance is nonnull) {
        return $this->shared();
      }
    }
    $this->instance = $this->provider->get($container);
    return $this->instance;
  }
}
