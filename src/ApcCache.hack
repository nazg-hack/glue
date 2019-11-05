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
use type Nazg\Glue\Exception\CacheNotFoundException;
use function apc_store;
use function apc_exists;
use function apc_fetch;

class ApcCache {

  public function __construct(
    private string $keyname
  ) {}

  public function save(
    Serializer\SerializeInterface $serializer
  ): void {
    if($this->exists()) {
      return;
    }
    apc_store($this->keyname, $serializer->serialize());
  }

  public function read(
    Serializer\UnserializeInterface $unserializer
  ): dict<string, (DependencyInterface, Scope)> {
    $success = null;
    $result = apc_fetch($this->keyname, inout $success);
    if (!$success) {
      throw new CacheNotFoundException('cache not found.');
    }
    return $unserializer->unserialize($result);
  }

  public function exists(): bool {
    return apc_exists($this->keyname);
  }
}
