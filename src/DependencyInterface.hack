namespace Nazg\Glue;

interface DependencyInterface {
  
  public function register<T>(
    Bind<T> $dependency
  ): void;

  public function resolve<T>(
    \Nazg\Glue\Container $container
  ): T;
}
