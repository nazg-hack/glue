<?hh // strict

namespace Nazg\Glue\Injection;

use type Nazg\Glue\Scope;

final class LazyNew<T> {
  
  public function __construct(
    private classname<T> $name,
    private vec<mixed> $params = vec[],
  ){ }

  public function getName(): classname<T> {
    return $this->name;
  }

  public function provide(): T {
    $class = new \ReflectionClass($this->name);
    $c = $class->getConstructor();
    if($c is \ReflectionMethod) {
      return $class->newInstanceArgs($this->params);
    }
    return $class->newInstanceWithoutConstructor();
  }
}
