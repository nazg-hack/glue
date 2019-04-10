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

use namespace Nazg\Glue\Exception;
use namespace HH\Lib\{C, Str};

<<__Sealed(CachedContainer::class)>>
class Container {
  protected dict<string, (DependencyInterface, Scope)> $bindings = dict[];
  private bool $isLock = false;

  public function bind<T>(
    typename<T> $id
  ): Bind<T> {
    return new Bind($this, $id);
  }

  public function add<T>(Bind<T> $bind): void {
    if($this->isLock()) {
      throw new Exception\ContainerNotLockedException(
        'Cannot modify container when locked.'
      );
    }
    $bound = $bind->getBound();
    if($bound is DependencyInterface) {
      $this->bindings[$bind->getId()] = tuple($bound, $bind->getScope());
    }
  }

  protected function resolve<T>(typename<T> $id): T {
    if ($this->has($id)) {
      list($bound, $scope) = $this->bindings[$id];
      if ($bound is DependencyInterface) {
        return $bound->resolve($this, $scope);
      }
    }
    throw new Exception\NotFoundException(
      Str\format('Identifier "%s" is not binding.', $id),
    );
  }

  public function get<T>(typename<T> $t): T {
    return $this->resolve($t);
  }

  <<__Rx>>
  public function isLock(): bool {
    return $this->isLock;
  }

  public async function lockAsync(): Awaitable<void> {
    $this->isLock = true;
  }

  public function has<T>(typename<T> $id): bool {
    return C\contains_key($this->bindings, $id);
  }

  public function registerModule(
    classname<ServiceModule> $moduleClassName
  ): void {
    new $moduleClassName()
    |> $$->provide($this);
  }

  <<__Rx>>
  public function getBindings(): dict<string, (DependencyInterface, Scope)> {
    return $this->bindings;
  }
}
