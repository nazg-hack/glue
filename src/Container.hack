namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};

class Container {
  private bool $lock = false;
  private dict<string, DependencyInterface> $bindings = dict[];

  public function bind<T>(
    typename<T> $id
  ): Bind<T> {
    return new Bind($this, $id);
  }

  public function add<T>(Bind<T> $bind): void {
    $bound = $bind->getBound();
    if($bound is DependencyInterface) {
      $bound->register($bind);
      $this->bindings[$bind->getId()] = $bound;
    }
  }

  protected function resolve<T>(typename<T> $id): T {
    if ($this->has($id)) {
      $bound = $this->bindings[$id];
      if ($bound is nonnull) {
        return $bound->resolve($id);
        /*
        if ($scope === Scope::SINGLETON) {
          return $this->shared($id);
        }
        return $callable($this);
        */
      }
    }
    throw new Exception\NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  public function get<T>(typename<T> $t): T {
    return $this->resolve($t);
  }

  <<__Memoize>>
  protected function shared<T>(typename<T> $id): T {
    //list($_, $callable) = $this->map[$id];
    //return $callable($this);
    throw new \Exception();
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
