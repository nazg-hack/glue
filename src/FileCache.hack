/**
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 * AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 * LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 * OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 * THE SOFTWARE.
 *
 * This software consists of voluntary contributions made by many individuals
 * and is licensed under the MIT license.
 *
 * Copyright (c) 2018-2019 Yuuki Takezawa
*/

namespace Nazg\Glue;

use namespace HH\Lib\Experimental\Filesystem;
use namespace Nazg\Glue\Serializer;

class FileCache {

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
