namespace Nazg\Glue;

use namespace HH\Lib\Experimental\Filesystem;
use namespace Nazg\Glue\Serializer;
use type HH\Lib\_Private\FileHandle;

class SerializeFile {

  public function __construct(
    private string $filename
  ) {}

  <<__ReturnDisposable>>
  protected function reader(): Filesystem\DisposableFileReadHandle {
    return Filesystem\open_read_only($this->filename);
  }

  public async function saveAsync(
    Serializer\SerializeInterface $serializer
  ): Awaitable<void> {
    if($this->exists()) {
      return;
    }
    await using $handle = $this->writer();
    await $handle->writeAsync($serializer->serialize());
    await $handle->closeAsync();
  }
  
  public async function readAsync(
    Serializer\UnserializeInterface $unserializer
  ): Awaitable<dict<string, (DependencyInterface, Scope)>> {
    await using $handle = $this->reader();
    return await $unserializer->unserializeAsync(
      $handle->readAsync()
    );
  }

  <<__ReturnDisposable>>
  protected function writer(): Filesystem\DisposableFileWriteHandle {
    return Filesystem\open_write_only(
      $this->filename,
      Filesystem\FileWriteMode::MUST_CREATE,
    );
  }

  public function exists(): bool {
    $path = new Filesystem\Path($this->filename);
    return $path->exists();
  }
}
