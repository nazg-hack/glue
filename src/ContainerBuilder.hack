namespace Nazg\Glue;

class ContainerBuilder {

  public function __construct(
    private bool $useCache = false,
    private string $cachefileName = ''
  ) {}

  public function make(): \Nazg\Glue\Container {
    if ($this->useCache) {
      return new \Nazg\Glue\CachedContainer(
        new BindingSerializer(new FileCache($this->cachefileName))
      );
    }
    return new \Nazg\Glue\Container();
  }

  final public function useCache(string $cacheFileName): void {
    $this->useCache = true;
    $this->cachefileName = $cacheFileName;
  }
}
