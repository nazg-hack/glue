namespace Nazg\Glue;

interface DependencyInterface {

  public function resolve<T>(
    Scope $scope
  ): T;
}
