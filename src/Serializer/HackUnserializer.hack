namespace Nazg\Glue\Serializer;

use type Nazg\Glue\Scope;
use type Nazg\Glue\DependencyInterface;
use function unserialize;

class HackUnserializer implements UnserializeInterface {

  public async function unserializeAsync(
    Awaitable<string> $bytes
  ): Awaitable<dict<string, (DependencyInterface, Scope)>> {
    $b = await $bytes;
    return unserialize($b);
  }
}
