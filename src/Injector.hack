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

use type ReflectionClass;
use type ReflectionMethod;

class Injector {

  public function __construct(
    private ReflectionClass $reflection
  ) {}

  public function getReflectionClass(): (ReflectionClass, ?vec<typename<mixed>>) {
    $constructor = $this->reflection->getConstructor();
    if($this->reflection->isInstantiable()) {
      if ($constructor is ReflectionMethod) {
        if ($constructor->getNumberOfParameters() !== 0) {
          $arguments = vec[];
          foreach($constructor->getParameters() as $parameter) {
            $arguments[] = $parameter->getTypehintText();
          }
          return tuple($this->reflection, $arguments);
        }
      }
      return tuple($this->reflection, null);
    }
    throw new \RuntimeException('reflection error');
  }
}
