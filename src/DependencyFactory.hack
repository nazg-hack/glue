namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str, Dict};

final class DependencyFactory {
  
  public function closureDependency<T>(
    typename<T> $concrete
  ): DependencyInterface {
    return new DependencyClosure($concrete);
  }
}
