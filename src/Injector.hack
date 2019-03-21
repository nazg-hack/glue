namespace Nazg\Glue;

use type ReflectionClass;
use type ReflectionMethod;

class Injector {

  public function __construct(
    private ReflectionClass $reflection
  ) {}

  public function getReflectionClass(): (ReflectionClass, ?vec<typename<mixed>>) {
    $constructor = $this->reflection->getConstructor();
    if($this->reflection->isInstantiable()) {
      if ($constructor is ReflectionMethod) {
        if ($constructor->getNumberOfParameters() !== 0) {
          $arguments = vec[];
          foreach($constructor->getParameters() as $parameter) {
            $arguments[] = $parameter->getTypehintText();
          }
          return tuple($this->reflection, $arguments);
        }
      }
      return tuple($this->reflection, null);
    }
    throw new \RuntimeException('reflection error');
  }
}
