namespace Nazg\Glue;

class CachedContainer extends \Nazg\Glue\Container {

  private bool $serialized = false;

  public function __construct(
    private BindingSerializer $serializer
  ) {
    $serialized = $serializer->hasSerializeFile();
    $this->detectBindings($serialized);
    $this->serialized = $serialized;
  }

  <<__Override>>
  public function add<T>(Bind<T> $bind): void {
    if(!$this->serialized) {
      parent::add($bind);
    }
  }

  <<__Override>>
  public async function lockAsync(): Awaitable<void> {
    await parent::lockAsync();
    if (!$this->serialized) {
      await $this->serializer->serializeAsync($this->getBindings());
    }
  }

  private function detectBindings(bool $serialized): void {
    if ($serialized) {
      $this->bindings = \HH\Asio\join($this->serializer->unserializeAsync());
    }
  }
}
