namespace Nazg\Glue;

use type RuntimeException;

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
