namespace Nazg\Glue\Serializer;

use type Nazg\Glue\Scope;
use type Nazg\Glue\DependencyInterface;
use function serialize;

class HackSerializer implements SerializeInterface {

  public function __construct(
    private dict<string, (DependencyInterface, Scope)> $bindings
  ) {}

  public function serialize(): string {
    return serialize($this->bindings);
  }
}
