<?hh // strict

namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str};
type CallableInjector = (function(\Nazg\Glue\Container): mixed);

class Container {
  private bool $lock = false;
  private dict<string, (Scope, CallableInjector)> $map = dict[];

  public function set<T>(
    classname<T> $id,
    CallableInjector $callback,
    Scope $scope = Scope::PROTOTYPE,
  ): void {
    if(!$this->lock) {
      $this->map[$id] = tuple($scope, $callback);
    }
  }

  <<__Rx>>
  protected function resolve<T>(classname<T> $id): mixed {
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

  <<__Rx>>
  public function getInstance<T>(classname<T> $t): T {
    $mixed = $this->resolve($t);
    invariant($mixed instanceof $t, "invalid use of incomplete type %s", $t);
    return $mixed;
  }

  <<__Memoize>>
  protected function shared<T>(classname<T> $id): mixed {
    list($_, $callable) = $this->map[$id];
    return $callable($this);
  }

  <<__Rx>>
  public function has(string $id): bool {
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
}
