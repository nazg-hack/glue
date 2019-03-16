namespace Nazg\Glue\Serializer;

use type Nazg\Glue\Scope;
use type Nazg\Glue\DependencyInterface;

interface UnserializeInterface {

  public function unserializeAsync(
    Awaitable<string> $bytes
  ): Awaitable<array<string, (DependencyInterface, Scope)>>;
}
