namespace Nazg\Glue;

use type ReflectionClass;
use type ReflectionMethod;

type Transaction = shape();
class Injector {

  public function __construct(
    private ReflectionClass $reflection
  ) {}

  public function getReflectionClass(): (ReflectionClass, ?vec<typename<mixed>>) {
    $construtor = $this->reflection->getConstructor();
    if($this->reflection->isInstantiable()) {
      if ($construtor is ReflectionMethod) {
        if ($construtor->getNumberOfParameters() !== 0) {
          $arguments = vec[];
          foreach($construtor->getParameters() as $parameter) {
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
