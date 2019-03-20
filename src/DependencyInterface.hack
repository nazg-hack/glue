namespace Nazg\Glue;

interface DependencyInterface {

  public function resolve<T>(
    \Nazg\Glue\Container $container,
    Scope $scope
  ): T;
}
