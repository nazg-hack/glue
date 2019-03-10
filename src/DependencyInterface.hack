namespace Nazg\Glue;

interface DependencyInterface {
  
  public function register<T>(
    Bind<T> $dependency
  ): void;

  public function resolve<T>(
    string $id
  ): T;

  public function has<T>(
    string $id
  ): bool;
}
