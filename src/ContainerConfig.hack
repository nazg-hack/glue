namespace Nazg\Glue;

class ContainerConfig {

  public function __construct(
    private bool $enableCache = false,
    private string $cacheFile = ''
  ) {}

  public function enableCache(): bool {
    return $this->enableCache;
  }

  public function cacheFile(): string {
    return $this->cacheFile;
  }
}
