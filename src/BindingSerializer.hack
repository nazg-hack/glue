namespace Nazg\Glue;

use namespace Nazg\Glue\Serializer;

class BindingSerializer {

  public function __construct(
    protected FileCache $fileCache,
  ) {}

  final public async function unserializeAsync(
  ): Awaitable<dict<string, (DependencyInterface, Scope)>> {
    $r = await $this->fileCache->readAsync($this->getUnserializer());
    return $r;
  }

  final public async function serializeAsync(
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

  final public function hasSerializeFile(): bool {
    return $this->fileCache->exists();
  }
}
