namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;
use function array_key_exists;

final class DependencyClosure<T> implements DependencyInterface {
  
  private dict<string, Bind<T>> $index = dict[];

  public function __construct(
    private typename<T> $concrete
  ) {}

  public function register(
    Bind<T> $bind
  ): void {
    $this->index[$bind->getId()] = $bind;
  }

  public function resolve(string $id): T {
    if($this->has($id)) {
      $bind = $this->index[$id];
      $ref = new \ReflectionClass($bind->getBound());
      return $ref->newInstanceArgs([]);
    }
    throw new \Exception();
  }

  <<__Memoize, __Rx>>
  public function has(string $id): bool {
    return C\contains_key($this->index, $id);
  }
}
