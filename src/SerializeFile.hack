namespace Nazg\Glue;

use namespace HH\Lib\Experimental\Filesystem;
use type HH\Lib\_Private\FileHandle;

class SerializeFile {

  public function __construct(
    private string $filename
  ) {}

  public async function saveAsync(string $bytes): Awaitable<void> {
    await using $handle = $this->writer();
    await $handle->writeAsync($bytes);
    await $handle->closeAsync();
  }

  <<__ReturnDisposable>>
  protected function writer(): Filesystem\DisposableFileWriteHandle {
    return Filesystem\open_write_only(
      $this->filename,
      Filesystem\FileWriteMode::MUST_CREATE,
    );
  }
}
