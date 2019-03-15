namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str};

class Container {
  private bool $lock = false;
  private dict<string, (DependencyInterface, Scope)> $bindings = dict[];

  public function bind<T>(
    typename<T> $id
  ): Bind<T> {
    return new Bind($this, $id);
  }

  public function add<T>(Bind<T> $bind): void {
    $bound = $bind->getBound();
    if($bound is DependencyInterface) {
      $this->bindings[$bind->getId()] = tuple($bound, $bind->getScope());
    }
  }

  protected function resolve<T>(typename<T> $id): T {
    if ($this->has($id)) {
      list($bound, $scope) = $this->bindings[$id];
      if ($bound is DependencyInterface) {
        return $bound->resolve($scope);
      }
    }
    throw new Exception\NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  public function get<T>(typename<T> $t): T {
    return $this->resolve($t);
  }

  <<__Rx>>
  public function has<T>(typename<T> $id): bool {
    if($this->lock) {
      return C\contains_key($this->bindings, $id);
    }
    throw new Exception\ContainerNotLockedException(
      Str\format('Container was not locked.'),
    );
  }

  public function lock(): void {
    $this->lock = true;
  }

  public function unlock(): void {
    $this->lock = false;
  }

  public function registerModule(
    classname<ServiceModule> $moduleClassName
  ): void {
    new $moduleClassName()
    |> $$->provide($this);
  }
}
