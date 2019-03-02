namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str};

class Container<T> {
  private bool $lock = false;
  private dict<string, (Scope, (function(\Nazg\Glue\Container<T>): T))> $map = dict[];

  public function set(
    typename<T> $id,
    (function(\Nazg\Glue\Container<T>): T) $callback,
    Scope $scope = Scope::PROTOTYPE,
  ): void {
    if(!$this->lock) {
      $this->map[$id] = tuple($scope, $callback);
    }
  }

  protected function resolve(typename<T> $id): T {
    if ($this->has($id)) {
      list($scope, $callable) = $this->map[$id];
      if ($callable is nonnull) {
        if ($scope === Scope::SINGLETON) {
          return $this->shared($id);
        }
        return $callable($this);
      }
    }
    throw new Exception\NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  public function get(typename<T> $t): T {
    return $this->resolve($t);
  }

  <<__Memoize>>
  protected function shared(typename<T> $id): T {
    list($_, $callable) = $this->map[$id];
    return $callable($this);
  }

  <<__Rx>>
  public function has(typename<T> $id): bool {
    if($this->lock) {
      return C\contains_key($this->map, $id);
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

  public function remove<T>(typename<T> $id): void {
    if(!$this->lock) {
      $this->map = Dict\filter_with_key($this->map, ($k, $_) ==> $k !== $id);
    }
  }

  public function registerModule(
    classname<ServiceModule> $moduleClassName
  ): void {
    new $moduleClassName()
    |> $$->provide($this);
  }
}
