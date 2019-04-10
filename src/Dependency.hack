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

final class Dependency<T> extends AbstractDependency<T> implements DependencyInterface {

  public function __construct(
    private Injector $injector
  ) {}

  <<__Override>>
  public function resolve(
    \Nazg\Glue\Container $container,
    Scope $scope
  ): T {
    list($reflection, $args) = $this->injector->getReflectionClass();
    if($scope === Scope::SINGLETON) {
      if ($this->instance is nonnull) {
        return $this->shared();
      }
    }
    if($args is vec<_>) {
      $parameters = vec[];
      foreach($args as $arg) {
        $parameters[] = $container->get($arg);
      }
      $this->instance = $reflection->newInstanceArgs($parameters);
      return $this->instance;
    }
    $this->instance = $reflection->newInstance();
    return $this->instance;
  }
}
