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
