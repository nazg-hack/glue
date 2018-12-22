<?hh // strict

namespace Acme\HackDi;

use type Acme\HackDi\Exception\NotFoundException;
use namespace HH\Lib\{C, Str};
type TCallable = (function(\Acme\HackDi\Container): mixed);

enum Scope : int {
  PROTOTYPE = 0;
  SINGLETON = 1;
}

class Container {
  
  private dict<string, (Scope, TCallable)> $map = dict[];

  public function set<T as classname<T>>(
    T $id,
    TCallable $callback,
    Scope $scope = Scope::PROTOTYPE,
  ): void {
    $this->map[$id] = tuple($scope, $callback);
  }

  <<__Rx>>
  public function get<T as classname<T>>(T $id): mixed {
    if ($this->has($id)) {
      list($scope, $callable) = $this->map[$id];
      if ($callable is nonnull) {
        if ($scope === Scope::SINGLETON) {
          return $this->shared($id);
        }
        return $callable($this);
      }
    }
    throw new NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  <<__Memoize>>
  protected function shared(string $id): mixed {
    list($_, $callable) = $this->map[$id];
    return $callable($this);
  }

  <<__Rx>>
  public function has(string $id): bool {
    return C\contains_key($this->map, $id);
  }
}
