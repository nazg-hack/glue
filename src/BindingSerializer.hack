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
