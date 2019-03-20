namespace Nazg\Glue;

use namespace Nazg\Glue\Exception;
use namespace Nazg\Glue\Serializer;
use namespace HH\Lib\{C, Str};

class ContainerCache {

  public function __construct(
    protected SerializeFile $fileCache,
  ) {}

  public async function unserializeAsync(
  ): Awaitable<dict<string, (DependencyInterface, Scope)>> {
    $r = await $this->fileCache->readAsync($this->getUnserializer());
    return $r;
  }

  public async function serializeAsync(
    dict<string, (DependencyInterface, Scope)> $bindings
  ): Awaitable<void> {
    await $this->fileCache->saveAsync($this->getSerializer($bindings));
  }

  protected function getSerializer(
    dict<string, (DependencyInterface, Scope)> $bindings
  ): Serializer\SerializeInterface {
    return new Serializer\HackSerializer($bindings);
  }

  protected function getUnserializer(): Serializer\UnserializeInterface {
    return new Serializer\HackUnserializer();
  }
}
