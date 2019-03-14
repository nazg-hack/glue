namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};
use type ReflectionClass;
use type ReflectionMethod;
use type RuntimeException;
use function array_key_exists;

abstract class AbstractDependency<T> implements DependencyInterface {

  protected ?T $instance;

  <<__Memoize>>
  protected function shared(): T {
    if ($this->instance is nonnull) {
      return $this->instance;
    }
    throw new RuntimeException();
  }
}
